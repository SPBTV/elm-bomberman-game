module Main exposing (..)

import Html exposing (..)
import Html.App as Html


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
    {}


init : ( Model, Cmd Msg )
init =
    ( initialModel
    , Cmd.none
    )



-- UPDATE


type Msg
    = Message Player.Msg


update : Msg -> Model.Model -> ( Model.Model, Cmd Msg )
update msg model =
    case msg of
        Message str ->
            ( model, Cmd.none )

        Send ->
            ( model
            , WebSocket.send "ws://127.0.0.1:3000" "ping"
            )



-- SUBSCRIPTIONS


subscriptions : Model.Model -> Sub Msg
subscriptions model =
    WebSocket.listen "ws://127.0.0.1:3000" Message



-- VIEW


playerView : PlayerModel -> Html Msg
playerView model =
    div [ class "player" ] [ text (toString model.id) ]


view : Model.Model -> Html Msg
view model =
    div []
        (List.map Player.view model.players)
