view: user_facts {
      derived_table: {
      sql: SELECT
              order_items.user_id AS user_id
              ,COUNT(distinct order_items.order_id) AS lifetime_order_count
              ,SUM(order_items.sale_price) AS lifetime_revenue
              ,MIN(order_items.created_at) AS first_order_date
              ,MAX(order_items.created_at) AS latest_order_date
              FROM order_items
              GROUP BY 1
                 ;;
    }

    measure: count {
      type: count
      drill_fields: [detail*]
    }

    dimension: user_id {
      type: number
      sql: ${TABLE}.user_id ;;
    }

    dimension: lifetime_order_count {
      type: number
      sql: ${TABLE}.lifetime_order_count ;;
    }

    dimension: lifetime_revenue {
      type: number
      sql: ${TABLE}.lifetime_revenue ;;
    }

    dimension_group: first_order {
      type: time
      timeframes: [raw,date,week,month,quarter,year]
      sql: ${TABLE}.first_order ;;
    }

    dimension_group: latest_order {
      type: time
      timeframes: [raw,date,week,month,quarter,year]
      sql: ${TABLE}.latest_order ;;
    }

    set: detail {
      fields: [user_id, lifetime_order_count, lifetime_revenue, first_order_date, latest_order_date]
    }
  }
