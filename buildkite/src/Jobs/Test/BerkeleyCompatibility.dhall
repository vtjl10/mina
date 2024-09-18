let JobSpec = ../../Pipeline/JobSpec.dhall

let Pipeline = ../../Pipeline/Dsl.dhall

let PipelineTag = ../../Pipeline/Tag.dhall

let Cmd = ../../Lib/Cmds.dhall

let S = ../../Lib/SelectFiles.dhall

let Command = ../../Command/Base.dhall

let Docker = ../../Command/Docker/Type.dhall

let Size = ../../Command/Size.dhall

let dependsOn =
      [ { name = "MinaArtifactBullseye"
        , key = "daemon-berkeley-bullseye-docker-image"
        }
      ]

in  Pipeline.build
      Pipeline.Config::{
      , spec = JobSpec::{
        , dirtyWhen =
          [ S.strictlyStart (S.contains "src")
          , S.exactly "buildkite/scripts/check-compatibility" "sh"
          , S.exactly "buildkite/src/Jobs/Test/BerkeleyCompatibility" "dhall"
          ]
        , path = "Test"
        , tags = [ PipelineTag.Type.Long, PipelineTag.Type.Test ]
        , name = "BerkeleyCompatibility"
        }
      , steps =
        [ Command.build
            Command.Config::{
            , commands =
              [ Cmd.run "buildkite/scripts/check-compatibility.sh berkeley" ]
            , label = "Test: berkeley compatibilty test"
            , key = "berkeley-compatibilty-test"
            , target = Size.XLarge
            , docker = None Docker.Type
            , depends_on = dependsOn
            , timeout_in_minutes = Some +60
            }
        ]
      }
