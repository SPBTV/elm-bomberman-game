module Model exposing (Model, Player, initialPlayer)


type alias Player =
    { id : String
    , coords : { x : Int, y : Int }
    }


type alias Model =
    { current : Player
    , players : List Player
    }


initialPlayer : Player
initialPlayer =
    { id = ""
    , coords = { x = 0, y = 0 }
    }
