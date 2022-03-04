{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}

module Dot.Link.Types where

import Data.Aeson
import GHC.Generics

data SymbolicLink = SymbolicLink
  { -- | Path to the link to be created
    link :: FilePath,
    -- | Path to the target file
    target :: FilePath
  }
  deriving (Show, Generic, ToJSON, FromJSON)
