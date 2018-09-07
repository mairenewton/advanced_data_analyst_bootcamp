connection: "events_ecommerce"

include: "*.view.lkml"                       # include all views in this project

explore: whatever {
  from: users_no_pii
}
