import XMonad
import System.Exit (exitSuccess)
import GHC.IO.Handle.Types (Handle)
import XMonad.StackSet (current, screen, visible, Screen, workspace, tag, hidden)
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Data.List(sort, elemIndex)

import XMonad.Actions.CycleWS (moveTo, shiftTo)
import XMonad.Actions.PhysicalScreens

import XMonad.Util.NamedWindows(getName)
import XMonad.Util.Dmenu
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Run
import XMonad.Util.Scratchpad
import XMonad.Util.NamedScratchpad

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks)

import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.Spiral

import XMonad.Layout.LayoutModifier
import XMonad.Layout.Gaps
import XMonad.Layout.Renamed
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Layout.IndependentScreens

import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.WithAll (sinkAll, killAll)

-- Basic settings --
myModMask :: KeyMask
myModMask = mod4Mask

myFont = "mononoki-Regular Nerd Font Complete Mono"

myTerminal :: String
myTerminal = "kitty"

myBrowser :: String
myBrowser = "firefox"

myEditor :: String
myEditor = "nvim"

myBorderWidth :: Dimension
myBorderWidth = 2

myNormColor :: String
myNormColor = "#282c34"

myFocusColor :: String
myFocusColor = "#46d9ff"

workspaceNames = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

myWorkspaces = withScreens 2 workspaceNames
--myWorkspaces = withScreens 2 [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]

-- Layout settings --

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Layouts --
tall = renamed [Replace "tall"]
    $ smartBorders
    $ mySpacing 8
    $ Tall 1 (3/100) (1/2)
grid = renamed [Replace "grid"]
    $ smartBorders
    $ mySpacing 8
    $ Grid (16/10)
spirals = renamed [Replace "spirals"]
    $ mySpacing 8
    $ spiral (6/7)

myLayouts = 
    tall |||
    grid |||
    spirals |||
    noBorders Full

myLayoutHook = gaps [(U, 20)] $ myLayouts

-- Startup --

myStartupHook :: X ()
myStartupHook = do
    spawnOnce "picom -f"
    spawnOnce "nitrogen --restore"
    spawnOnce "volumeicon"

-- Scratchpads --

myScratchpads :: [NamedScratchpad]
myScratchpads = [
    NS "term" "kitty --name term" (resource =? "term") windowData,
    NS "pavucontrol" "pavucontrol" (className =? "Pavucontrol") windowData
    ] where windowData = (customFloating $ W.RationalRect 0.05 0.05 0.9 0.9)


-- Keys --
defaultKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [
    --  Reset the layouts on the current workspace to default
    ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    ]
    ++
    [((m .|. modm, k), windows $ onCurrentScreen f i)
        | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

myKeys :: [(String, X ())]
myKeys = [
    ("M-C-r", spawn "xmonad --recompile"),
    ("M-S-r", spawn "xmonad --restart"),
    ("M-S-q", io exitSuccess),
    ("M-<Return>", spawn "dmenu_run -i -p \"Run: \""),
    ("M-S-<Return>", spawn myTerminal),
    ("M-b", spawn myBrowser),
    ("M-d", spawn "discord"),
    ("<Print>", spawn "maim -s | xclip -selection clipboard -t image/png"),
    ("S-<Print>", spawn "maim | xclip -selection clipboard -t image/png"),
    ("C-<Print>", spawn "flameshot gui"),
    ("M-S-c", kill1),
    ("M-S-a", killAll),
    ("M-S-t", sinkAll),  --Floating windows to tilling
    ("M-.", onPrevNeighbour def W.view),
    ("M-,", onPrevNeighbour def W.view),
    ("M-S-.", onPrevNeighbour def W.shift),
    ("M-S-,", onPrevNeighbour def W.shift),
    ("M-<Space>", sendMessage NextLayout),
    ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute"),
    ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute"),
    ("M-n", refresh),
    ("M-j", windows W.focusDown),
    ("M-k", windows W.focusUp),
    ("M-S-j", windows W.swapDown),
    ("M-S-k", windows W.swapUp),
    ("M-m", windows W.focusMaster),
    ("M-S-m", windows W.swapMaster),
    ("M-h", sendMessage Shrink),
    ("M-l", sendMessage Expand),
    ("M-i", sendMessage (IncMasterN 1)),
    ("M-o", sendMessage (IncMasterN (-1))),
    ("M-æ", namedScratchpadAction myScratchpads "term"),
    ("M-ø", namedScratchpadAction myScratchpads "pavucontrol")
    ]

-- XMobar --

spawnXMobar :: MonadIO m => Int -> m (Int, Handle)
spawnXMobar i = (spawnPipe $ "xmobar" ++ " -x " ++ show i ++ " $HOME/.config/xmobarrc") >>= (\handle -> return (i, handle))
  --xmproc1 <- spawnPipe ("xmobar -x 0 $HOME/.config/xmobarrc")

spawnXMobars :: MonadIO m => Int -> m [(Int, Handle)]
spawnXMobars n = mapM spawnXMobar [0..n-1]

visibleScreens cws = ([current cws]) ++ (visible cws)

convertPipe (i, pipe) = dynamicLogWithPP $ def {
    ppOutput = hPutStrLn pipe,
    ppCurrent = \s -> s,
    ppVisible = \s -> show i,
    ppHidden  = \s -> "h",
    ppLayout  = \s -> s,
    ppTitle   = \s -> "t"
    }

joinToString :: [String] -> String
joinToString workspaceIds = foldl (++) "" workspaceIds

getWName = snd . unmarshall . tag
getFName a = if (length $ W.integrate' $ W.stack a) > 0 then "["++(getWName a)++"]" else getWName a

visibleS a = "<fc=#ffcccb>" ++ a ++ "</fc>"
hiddenS a = a
layoutS a = "<fc=#7b7cff>" ++  a ++ "</fc>"
nameS a = "<fc=#7bff7c>" ++ a ++ "</fc>"

getWorkspace a i = workspace $ head $ filter ((==) (S i) . screen) $ visibleScreens a

getLayout a i = layoutS $ description $ W.layout $ getWorkspace a i
getWindowName a i = maybe (pure "") (fmap show . getName) . fmap W.focus $ W.stack $ getWorkspace a i

pair f a = (flip elemIndex workspaceNames $ getWName a, f $ getFName a)
 
getVisible :: WindowSet -> (Int, Handle) -> [(Maybe Int, String)]
getVisible currentWindowSet (i, xmobarPipe) =
    map (pair visibleS . workspace) $ filter ((==) (S i) . screen) $ visibleScreens currentWindowSet

getHidden :: WindowSet -> (Int, Handle) -> [(Maybe Int, String)]
getHidden currentWindowSet (i, xmobarPipe) =
    map (pair hiddenS) $ filter ((==) (S i) . unmarshallS . tag) $ filter (flip elem workspaceNames . getWName) $ hidden currentWindowSet

myLogHookForPipe :: WindowSet -> (Int, Handle) -> X ()
myLogHookForPipe currentWindowSet (i, xmobarPipe) = do
    io $ hPutStrLn xmobarPipe $
        foldr1 (\a b -> a ++ " <fc=#666666>|</fc> " ++ b) $ (map (snd) $ sort $
        (getHidden currentWindowSet (i, xmobarPipe)) ++ (getVisible currentWindowSet (i, xmobarPipe))) ++ [getLayout currentWindowSet i]
    
    

myLogHook :: [(Int, Handle)] -> X ()
myLogHook xmobarPipes = do
    currentWindowSet <- gets windowset
    --mapM_ convertPipe xmobarPipes
    mapM_ (myLogHookForPipe currentWindowSet) xmobarPipes

-- Main --

main :: IO ()
main = do
  n <- countScreens
  xmobarPipes <- spawnXMobars n
  xmonad $ ewmh def
    {
        terminal            = myTerminal,
        workspaces          = myWorkspaces,
        modMask             = myModMask,
        startupHook         = myStartupHook,
        layoutHook          = myLayoutHook,
        borderWidth         = myBorderWidth,
        normalBorderColor   = myNormColor,
        focusedBorderColor  = myFocusColor,
        keys                = defaultKeys,
        logHook             = myLogHook xmobarPipes,
        manageHook = namedScratchpadManageHook myScratchpads
    } `additionalKeysP` myKeys




