module Main exposing (..)

import Html exposing (Html, text, div, h1, h3, img)
import Html.Attributes exposing (src, class)
import Html.Events exposing (..)

---- MODEL ----

type alias ImageState =
    { imageStatus: LoadingState
    , imageSrc: String
    }

type LoadingState
    = Loading
    | Loaded
    | Error

type alias Model =
    { images: ImageState
    }

initialState: Model
initialState =
    { images =
        { imageSrc = "http://placehold.it/300x300"
        , imageStatus = Loading
        }
    }

init : ( Model, Cmd Msg )
init =
    ( initialState, Cmd.none )

---- UPDATE ----

type Msg
    = SetImageState LoadingState
    | NoOp

updateImageState : ImageState -> LoadingState -> ImageState
updateImageState oldState loadingState =
    { oldState | imageStatus = loadingState }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        oldState = model.images
    in
        case msg of
            SetImageState newState ->
                ({ model | images = updateImageState oldState newState }, Cmd.none )
            NoOp ->
                ( model, Cmd.none )


---- VIEW ----

lazyImage : ImageState -> Html Msg
lazyImage imageState =
    let
        displayContent: Html Msg
        displayContent =
            case imageState.imageStatus of
                Loaded -> img [ src imageState.imageSrc ] []
                Loading -> h3 [] [ text "Loading image..." ]
                Error -> h3 [] [ text  "Something went wrong..."]
    in
        div [ class "ImageContainer", onClick (SetImageState Loaded) ]
            [ displayContent ]

view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Your Elm App is working!" ]
        , lazyImage model.images
        ]


---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
