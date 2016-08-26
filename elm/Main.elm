module Main exposing (..)

import Keyboard
import Html exposing (..)
import Html.App as Html
import Html.Events exposing (onClick)
import Html.Attributes exposing (
  class,
  style)


-- import Html.Events exposing (..)

import List exposing (..)
import WebSocket


-- import Json.Decode exposing (Decoder, int, string, object2, (:=))


main : Program Never
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Player =
    { id : String
    , coords : { x : Int, y : Int }
    }


initialPlayer : Player
initialPlayer =
    { id = ""
    , coords = { x = 0, y = 0 }
    }


type alias Model =
    { players : List Player
    }


initialModel : Model
initialModel =
    { players =
        [ { id = "1", coords = { x = 0, y = 0 } }
        , { id = "2", coords = { x = 10, y = 10 } }
        , { id = "3", coords = { x = 20, y = 20 } }
        , { id = "4", coords = { x = 30, y = 30 } }
        ]
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel
    , Cmd.none
    )



-- UPDATE


type Msg
    = Message String
    | Send
    | KeyMsg Keyboard.KeyCode


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Message str ->
            ( model, Cmd.none )

        Send ->
            ( model
            , WebSocket.send "ws://127.0.0.1:3000" "ping"
            )
        KeyMsg code ->
          (
            model
            , WebSocket.send "ws://127.0.0.1:3000" (toString code)
          )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
      [ WebSocket.listen "ws://127.0.0.1:3000" Message
      , Keyboard.presses KeyMsg
      ]


-- VIEW


playerView : Player -> Html Msg
playerView model =
    let
        playerStyle =
            style
                [ ( "top", (toString (model.coords.x * 10) ++ "px") )
                , ( "left", (toString (model.coords.y * 10) ++ "px") )
                ]
    in
        div [
          class "player",
          playerStyle,
          onClick Send
        ] [ text (toString model.id) ]


view : Model -> Html Msg
view model =
    div []
        (List.map playerView model.players)
