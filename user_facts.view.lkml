view: user_facts {
    derived_table: {
      sql: SELECT
        user_id,
        COUNT(*) as lifetime_order_items,
        SUM(sale_price) as lifetime_sales,
        COUNT(DISTINCT order_id) as lifetime_orders,
        MIN(created_at) as first_order_date,
        MAX(created_at) as latest_order_date
      FROM order_items
      GROUP BY user_id
       ;;
    }

    dimension: user_id {
      primary_key: yes
      hidden: yes
      type: number
      sql: ${TABLE}.user_id ;;
    }

    dimension: lifetime_order_items {
      type: number
      sql: ${TABLE}.lifetime_order_items ;;
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
      sql: ${TABLE}.first_order_date ;;
    }

    dimension_group: latest_order_date {
      type: time
      timeframes: [raw, date]
      sql: ${TABLE}.latest_order_date ;;
    }

  }
