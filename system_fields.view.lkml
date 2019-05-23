view: system_fields {
 extension: required
  dimension: id {
    sql: ${TABLE}.id ;;
  }
  dimension_group: created {
    type: time
    timeframes: [date,week,month]
  }
}
