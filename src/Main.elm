module Main exposing (..)

import Html exposing (Html, text, div, h1, h3, img)
import Html.Attributes exposing (attribute, src, class)
import Html.Events exposing (..)
import Json.Decode

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
    { images: List ImageState
    }

initialState: Model
initialState =
    { images =
        [
            { imageSrc = "http://placehold.it/300x300"
            , imageStatus = Loading 
            }
        ,
            { imageSrc = "http://placehold.it/302x302"
            , imageStatus = Loading
            }
        ]
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
                Loaded -> img [ class "LazyImage LazyImage--Ready", src imageState.imageSrc ] []
                Loading -> img [ class "LazyImage", src imageState.imageSrc, on "load" (Json.Decode.succeed (SetImageState Loaded)) ] [ text "Loading image..." ]
                Error -> h3 [] [ text  "Something went wrong..."]
    in
        div [ class "ImageContainer", onClick (SetImageState Loaded) ]
            [ displayContent ]

view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "This is the gallery..." ]
        , h1 [] [ text "Below this, you'll find the image." ]
        , lazyImage model.images
        , h3 [] [ text "The image will appear above." ]
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
