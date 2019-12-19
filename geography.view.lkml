view: geography {
 extension: required

dimension: city {
  type: string
  sql: ${TABLE}.city ;;
}
dimension: state {
  type: string
  sql: ${TABLE}.state ;;
}
dimension: country {
  type: string
  sql: ${TABLE}.cicountryty ;;
}
dimension: region {
  type: string
  sql: CASE WHEN ${state} = 'Maine' THEN 'Northeast'
  WHEN ${state} = 'Massachusetts' THEN 'Northeast'
  WHEN ${state} = 'Rhode Island' THEN 'Northeast'
  WHEN ${state} = 'Connecticut' THEN 'Northeast'
  WHEN ${state} = 'New Hampshire' THEN 'Northeast'
  WHEN ${state} = 'Vermont' THEN 'Northeast'
  WHEN ${state} = 'New York' THEN 'Northeast'
  WHEN ${state} = 'Pennsylvania' THEN 'Northeast'
  WHEN ${state} = 'New Jersey' THEN 'Northeast'
  WHEN ${state} = 'Delaware' THEN 'Northeast'
  WHEN ${state} = 'Maryland' THEN 'Northeast'
  WHEN ${state} = 'West Virginia' THEN 'Southeast'
  WHEN ${state} = 'Virginia' THEN 'Southeast'
  WHEN ${state} = 'Kentucky' THEN 'Southeast'
  WHEN ${state} = 'Tennessee' THEN 'Southeast'
  WHEN ${state} = 'North Carolina' THEN 'Southeast'
  WHEN ${state} = 'South Carolina' THEN 'Southeast'
  WHEN ${state} = 'Georgia' THEN 'Southeast'
  WHEN ${state} = 'Alabama' THEN 'Southeast'
  WHEN ${state} = 'Mississippi' THEN 'Southeast'
  WHEN ${state} = 'Arkansas' THEN 'Southeast'
  WHEN ${state} = 'Louisiana' THEN 'Southeast'
  WHEN ${state} = 'Florida' THEN 'Southeast'
  WHEN ${state} = 'Ohio' THEN 'Midwest'
  WHEN ${state} = 'Indiana' THEN 'Midwest'
  WHEN ${state} = 'Michigan' THEN 'Midwest'
  WHEN ${state} = 'Illinois' THEN 'Midwest'
  WHEN ${state} = 'Missouri' THEN 'Midwest'
  WHEN ${state} = 'Wisconsin' THEN 'Midwest'
  WHEN ${state} = 'Minnesota' THEN 'Midwest'
  WHEN ${state} = 'Iowa' THEN 'Midwest'
  WHEN ${state} = 'Kansas' THEN 'Midwest'
  WHEN ${state} = 'Nebraska' THEN 'Midwest'
  WHEN ${state} = 'South Dakota' THEN 'Midwest'
  WHEN ${state} = 'North Dakota' THEN 'Midwest'
  WHEN ${state} = 'Texas' THEN 'Southwest'
  WHEN ${state} = 'Oklahoma' THEN 'Southwest'
  WHEN ${state} = 'New Mexico' THEN 'Southwest'
  WHEN ${state} = 'Arizona' THEN 'Southwest'
  WHEN ${state} = 'Colorado' THEN 'West'
  WHEN ${state} = 'Wyoming' THEN 'West'
  WHEN ${state} = 'Montana' THEN 'West'
  WHEN ${state} = 'Idaho' THEN 'West'
  WHEN ${state} = 'Washington' THEN 'West'
  WHEN ${state} = 'Oregon' THEN 'West'
  WHEN ${state} = 'Utah' THEN 'West'
  WHEN ${state} = 'Nevada' THEN 'West'
  WHEN ${state} = 'California' THEN 'West'
  WHEN ${state} = 'Alaska' THEN 'West'
  WHEN ${state} = 'Hawaii' THEN 'West'
  ELSE 'Outside US'
  END ;;
}

dimension: location {
  type: string
  sql: ${TABLE}.location ;;
}
   }
