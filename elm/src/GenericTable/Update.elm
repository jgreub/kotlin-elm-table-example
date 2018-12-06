module GenericTable.Update exposing (updateQueryOptionsFilter)

import GenericTable.Core exposing (QueryOptions, Filter, FilterEvent)

updateQueryOptionsFilter : QueryOptions -> FilterEvent -> QueryOptions
updateQueryOptionsFilter queryOptions filter =
  {queryOptions | filters = updateFilters queryOptions.filters filter}

updateFilters : List Filter -> FilterEvent -> List Filter
updateFilters filters filter =
  let
    filteredFilters = List.filter (\f -> f.name /= filter.name) filters
  in
    if String.isEmpty filter.value then
      filteredFilters
    else
      filter :: filteredFilters