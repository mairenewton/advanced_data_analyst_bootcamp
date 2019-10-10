view: distribution_centers {
  sql_table_name: public.distribution_centers ;;

  # Dimensions

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  # Measures

  measure: count {
    type: count
    drill_fields: [id, name, products.count]
  }
}
