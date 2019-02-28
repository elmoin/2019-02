module Main exposing (main)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


type alias Model =
    { count : Int }


initialModel : Model
initialModel =
    { count = 0 }


type Msg
    = Increment Int
    | Decrement Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment i ->
            { model | count = model.count + i }

        Decrement i ->
            { model | count = model.count - i }


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick (Increment 2) ] [ text "+1" ]
        , div [] [ text <| String.fromInt model.count ]
        , button [ onClick (Decrement 2) ] [ text "-1" ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
