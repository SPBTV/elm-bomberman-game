module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Events exposing (..)
import WebSocket


-- import Json.Decode exposing (Decoder, int, string, object2, (:=))

import Model exposing (Model, Player, initialPlayer)


main : Program Never
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


init : ( Model, Cmd Msg )
init =
    ( { current = initialPlayer
      , players = []
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Message String
    | Send


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Message str ->
            ( model, Cmd.none )

        Send ->
            ( model
            , WebSocket.send "ws://127.0.0.1:3000" model.current.id
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    WebSocket.listen "ws://127.0.0.1:3000" Message



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [] []
        , span [] [ text model.current.id ]
        , button [ onClick Send ] [ text "Send" ]
        ]
