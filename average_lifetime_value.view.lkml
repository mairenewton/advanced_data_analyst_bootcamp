view: average_lifetime_value {
  derived_table: {
    sql: SELECT
          "users"."id" AS "users.id",
          COUNT(DISTINCT order_items.order_id) AS "count_of_order_id",
          COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE( CAST(inventory_items.cost AS DOUBLE PRECISION) ,0)*(1000000*1.0)) AS DECIMAL(38,0))) + CAST(STRTOL(LEFT(MD5(CAST( inventory_items.id   AS VARCHAR)),15),16) AS DECIMAL(38,0))* 1.0e8 + CAST(STRTOL(RIGHT(MD5(CAST( inventory_items.id   AS VARCHAR)),15),16) AS DECIMAL(38,0)) ) - SUM(DISTINCT CAST(STRTOL(LEFT(MD5(CAST( inventory_items.id   AS VARCHAR)),15),16) AS DECIMAL(38,0))* 1.0e8 + CAST(STRTOL(RIGHT(MD5(CAST( inventory_items.id   AS VARCHAR)),15),16) AS DECIMAL(38,0))) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0) AS "sum_of_cost"
      FROM
          "public"."order_items" AS "order_items"
          LEFT JOIN "public"."users" AS "users" ON "order_items"."user_id" = "users"."id"
          LEFT JOIN "public"."inventory_items" AS "inventory_items" ON "order_items"."inventory_item_id" = "inventory_items"."id"
      GROUP BY
          1
      ORDER BY
          2 DESC
      LIMIT 500
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: users_id {
    type: number
    sql: ${TABLE}."users.id" ;;
  }

  dimension: count_of_order_id {
    type: number
    sql: ${TABLE}.count_of_order_id ;;
  }

  dimension: sum_of_cost {
    type: number
    sql: ${TABLE}.sum_of_cost ;;
  }
measure: average_lifetime_order_count {
  type: average
  sql: ${average_lifetime_order_count} ;;
}

measure: average_lifetime_revenue {
  type: sum
  sql: ${average_lifetime_order_count} ;;
}
  set: detail {
    fields: [users_id, count_of_order_id, sum_of_cost]
    }
  }
