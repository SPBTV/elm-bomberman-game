module Main exposing (..)

import Keyboard
import Html exposing (..)
import Html.App as Html
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, style)
import Playground
import Json.Decode exposing (..)
import WebSocket


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
    , x : Int
    , y : Int
    }


initialPlayer : Player
initialPlayer =
    { id = ""
    , x = 0
    , y = 0
    }


type alias Model =
    { players : List Player
    }


initialModel : Model
initialModel =
    { players =
        [ { id = "1", x = 1, y = 1 }
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
    | Send String
    | KeyMsg Keyboard.KeyCode


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Message str ->
            let
                result =
                    decodeString decodeMessage str
            in
                case result of
                    Ok players ->
                        ( { model | players = players }, Cmd.none )

                    Err _ ->
                        ( model, Cmd.none )

        Send str ->
            ( model
            , WebSocket.send "ws://127.0.0.1:3000" str
            )

        KeyMsg code ->
            ( model
            , WebSocket.send "ws://127.0.0.1:3000" (toString code)
            )



-- SUBSCRIPTIONS


decodeMessage : Decoder (List Player)
decodeMessage =
    at [ "players" ]
        (list
            (object3 Player
                ("id" := string)
                ("x" := int)
                ("y" := int)
            )
        )


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
                [ ( "top", (toString (model.x * 20) ++ "px") )
                , ( "left", (toString (model.y * 20) ++ "px") )
                ]
    in
        div
            [ class "player"
            , playerStyle
            , onClick (Send (toString model.id))
            ]
            []


view : Model -> Html Msg
view model =
    div [ class "map" ]
        [ (div []
            [ Playground.render
                { tiles =
                    [ [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ]
                    , [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ]
                    , [ 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1 ]
                    , [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ]
                    , [ 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1 ]
                    , [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ]
                    , [ 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1 ]
                    , [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ]
                    , [ 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1 ]
                    , [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ]
                    , [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ]
                    ]
                }
            ]
          )
        , (div []
            (List.map playerView model.players)
          )
        ]
