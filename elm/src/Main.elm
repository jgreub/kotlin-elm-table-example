import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as JD

main =
  Html.program
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }


-- MODEL

type alias Fruit =
  { name : String,
    color: String
  }

type alias Model = (List Fruit)

init : (Model, Cmd Msg)
init =
  ([], getFruits)


-- UPDATE

type Msg
  = GotFruits (Result Http.Error (List Fruit))

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GotFruits (Ok fruits) ->
      (fruits, Cmd.none)

    GotFruits (Err _) ->
      ([], Cmd.none)


-- VIEW

view : Model -> Html Msg
view model =
  table [] (drawHeader :: (List.map drawFruit model))

drawHeader : Html Msg
drawHeader =
  thead [ style [ ("backgroundColor", "lightgray") ] ] [
    tr [] [ td [] [text "Name"]
      ,  td [] [text "Color"]
    ]
  ]

drawFruit : Fruit -> Html Msg
drawFruit fruit =
  tr [] [ td [] [text fruit.name], td [] [text fruit.color] ]


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- HTTP

getFruits : Cmd Msg
getFruits =
  Http.send GotFruits (Http.get "/fruit?name=Apple" decodeFruits)

decodeFruits : JD.Decoder (List Fruit)
decodeFruits =
  JD.list decodeFruit

decodeFruit : JD.Decoder Fruit
decodeFruit =
  JD.map2 Fruit
    (JD.field "name" JD.string)
    (JD.field "color" JD.string)