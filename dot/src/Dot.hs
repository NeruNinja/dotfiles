{-# LANGUAGE ImportQualifiedPost #-}

module Dot
  ( dot,
  )
where

import Data.Aeson qualified as JSON
import Data.ByteString.Lazy qualified as BS
import Dot.Link.Types
import Dot.Options
import Options.Applicative

readJsonSpec :: JsonSpecInput -> IO (Maybe [SymbolicLink])
readJsonSpec input =
  JSON.decode <$> case input of
    CommandLineArgument spec -> pure spec
    ReadStandardInput -> BS.getContents

dot :: IO ()
dot = do
  command <- execParser dotOptions
  case command of
    Check -> putStr "Not yet implemented."
    Link input -> readJsonSpec input >>= print
    Switch -> putStr "Not yet implemented."
    Upgrade -> putStr "Not yet implemented."
