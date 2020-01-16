create table grocerylist (
  id integer primary key,
  item_name text not null,
  price real not null,
  date_purch text not null,
  store_name text not null,
  category text not null,
  quantity real,
  unit txt,
  description text
);
