import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as JD

main =
  Html.program
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }

init : (Model, Cmd Msg)
init =
  (Model [] "", getFruits "")


-- MODEL

type alias Fruit =
  { name : String,
    color: String
  }

type alias Model =
  { fruits: List Fruit
  , nameFilter: String
  }


-- UPDATE

type Msg
  = GotFruits (Result Http.Error (List Fruit))
  | FilterName String

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GotFruits (Ok fruits) ->
      ({model | fruits = fruits}, Cmd.none)

    GotFruits (Err _) ->
      ({model | fruits = []}, Cmd.none)

    FilterName nameFilter ->
      ({model | nameFilter = nameFilter}, getFruits nameFilter)


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ drawTable model.fruits
    , input [ onInput FilterName ] []
    ]

drawTable : List Fruit -> Html Msg
drawTable fruits =
  table [] (drawHeader :: (List.map drawRow fruits))

drawHeader : Html Msg
drawHeader =
  thead [ style [ ("backgroundColor", "lightgray") ] ] [
    tr [] [ td [] [text "Name"], td [] [text "Color"] ]
  ]

drawRow : Fruit -> Html Msg
drawRow fruit =
  tr [] [ td [] [text fruit.name], td [] [text fruit.color] ]


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- HTTP

getFruits : String -> Cmd Msg
getFruits nameFilter =
  let
    queryParams =
      if not (String.isEmpty nameFilter) then
        "?name=" ++ nameFilter
      else
        ""
  in
    Http.send GotFruits (Http.get ("/fruit" ++ queryParams) decodeFruits)

decodeFruits : JD.Decoder (List Fruit)
decodeFruits =
  JD.list decodeFruit

decodeFruit : JD.Decoder Fruit
decodeFruit =
  JD.map2 Fruit
    (JD.field "name" JD.string)
    (JD.field "color" JD.string)