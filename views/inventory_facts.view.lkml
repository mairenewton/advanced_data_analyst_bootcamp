view: inventory_facts {
    derived_table: {
      sql: SELECT
        product_sku,
        SUM(cost) as total_cost,
        SUM(case when sold_at is NOT NULL then cost ELSE null END) as cost_of_goods_sold
      FROM inventory_items
      GROUP BY product_sku
       ;;
    }

    dimension: product_sku {
      primary_key:  yes
      type: string
      sql: ${TABLE}.product_sku ;;
    }

    dimension: cost {
      hidden:  yes
      type:  number
      sql:  ${TABLE}.total_cost ;;
    }

    dimension: cost_of_goods_sold {
      type: number
      sql: ${TABLE}.cost_of_goods_sold ;;
    }

    measure: total_cost {
      type:  sum
      sql:  ${cost} ;;
      value_format_name:  usd
    }

    measure: total_cogs {
      type:  sum
      sql:  ${cost_of_goods_sold} ;;
      value_format_name:  usd
    }

    set: detail {
      fields: [product_sku, total_cost, cost_of_goods_sold]
    }
  }
