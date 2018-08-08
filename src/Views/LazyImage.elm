module Views.LazyImage exposing (..)

import Html exposing (Html, img, div)
import Html.Events exposing (..)
import Html.Attributes exposing (..)

type alias ImageState =
    { imageStatus: LoadingState
    , imgSrc: String
    }

type LoadingState
    = Loading
    | Loaded
    | Error

type ImageMsg
    = SetState LoadingState
    | NoOp

lazyImage : ImageState -> Html ImageMsg
lazyImage model =
    div [ class "ImageContainer" ]
        [ img [ src "http://placehold.it/300x300", onClick (SetState Loaded) ] []
        ]
