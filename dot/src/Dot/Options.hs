module Dot.Options
  ( Command (..),
    JsonSpecInput (..),
    dotOptions,
  )
where

import Options.Applicative

data JsonSpecInput
  = CommandLineArgument String
  | ReadStandardInput
  deriving (Show)

data Command
  = Check
  | Link JsonSpecInput
  | Switch
  | Upgrade
  deriving (Show)

checkCommand :: Parser Command
checkCommand = pure Check

linkCommand :: Parser Command
linkCommand = stdinCommand <|> argumentCommand
  where
    stdinCommand =
      pure $ Link ReadStandardInput

    argumentCommand =
      Link . CommandLineArgument
        <$> argument str (metavar "JSON-SPECIFICATION")

switchCommand :: Parser Command
switchCommand = pure Switch

upgradeCommand :: Parser Command
upgradeCommand = pure Upgrade

withInfo :: Parser a -> String -> ParserInfo a
withInfo parser = info (parser <**> helper) . progDesc

options :: Parser Command
options =
  subparser $
    command "check" (checkCommand `withInfo` "Run checks on the Nix flake")
      <> command "link" (linkCommand `withInfo` "Link files in the home directory")
      <> command "switch" (switchCommand `withInfo` "Rebuild and switch NixOS configuration")
      <> command "upgrade" (upgradeCommand `withInfo` "Update flake inputs, rebuild, and switch")

dotOptions :: ParserInfo Command
dotOptions = options `withInfo` "@NeruNinja's dotfiles management tool"
