module Playground exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

-- MODEL

type alias Model = {
    tiles : List (List Int)
}


-- UPDATE

type Msg
    = Init (List (List Int))
    | DestroyBox (Int, Int)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Init tiles ->
            {model | tiles = tiles } ! []
        DestroyBox (x, y) ->
            model ! []

-- VIEW PG

render : Model -> Html Msg
render model =
    div
        [class "playground"]
        (List.map (\pg_row -> div [class "row"] [text (toString (List.length pg_row))]) model.tiles)