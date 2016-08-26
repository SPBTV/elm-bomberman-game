module Playground exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


-- MODEL


type alias Model =
    { tiles : List (List Int)
    }



-- UPDATE


type Msg
    = Init (List (List Int))
    | DestroyBox ( Int, Int )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Init tiles ->
            { model | tiles = tiles } ! []

        DestroyBox ( x, y ) ->
            model ! []



-- VIEW PG


renderRow row =
    div [ class "row" ]
        (List.map
            (\cell -> div [ class ("cell cell_" ++ (toString cell)) ] [])
            row
        )


render : Model -> Html m
render model =
    div
        [ class "playground" ]
        (List.map renderRow model.tiles)
