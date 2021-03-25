view: ldt_user_facts {
    derived_table: {
      sql: SELECT
              user_id,
              SUM(sale_price) AS LIFETIME_SALES,
              COUNT(*) AS LIFETIME_ORDERS,
              MIN(created_at) AS FIRST_ORDER_DATE,
              MAX(created_at) AS LAST_ORDER_DATE
              FROM public.order_items
              GROUP BY 1
               ;;
    }

    dimension: user_id {
      type: number
      hidden: yes
      sql: ${TABLE}.user_id ;;
    }

    dimension: lifetime_sales {
      type: number

      sql: ${TABLE}.lifetime_sales ;;
    }

    dimension: lifetime_orders {
      type: number

      sql: ${TABLE}.lifetime_orders ;;
    }

    dimension_group: first_order_date {
      type: time
      timeframes: [raw,date]
      sql: ${TABLE}.first_order_date ;;
    }

    dimension_group: last_order_date {
      type: time
      timeframes: [raw,date]
      sql: ${TABLE}.last_order_date ;;
    }

   measure: avg_lifetime_sales {
     type: average
    sql: ${lifetime_sales} ;;
   }

   measure: avg_lifetime_orders {
     type: average
    sql: ${lifetime_orders} ;;
   }
  }
