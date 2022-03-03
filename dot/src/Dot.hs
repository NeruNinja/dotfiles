module Dot
  ( dot,
  )
where

import Dot.Options
import Options.Applicative

dot :: IO ()
dot = execParser dotOptions >>= print
