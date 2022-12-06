CREATE SCHEMA arke_system
  create table arke_unit
  (
      id            varchar(255)              not null
          primary key,
      arke_id       varchar(255)              not null,
      data          jsonb default '{}'::jsonb not null,
      configuration jsonb default '{}'::jsonb not null,
      inserted_at   timestamp(0)              not null,
      updated_at    timestamp(0)              not null
  )

  create table arke_link
  (
      type          varchar(255) default 'link'::character varying not null,
      parent_id     varchar(255)                                   not null
          references arke_system.arke_unit,
      child_id      varchar(255)                                   not null
          references arke_system.arke_unit,
      configuration jsonb        default '{}'::jsonb               not null,
      primary key (parent_id, child_id, configuration)
  )

  create index  arke_link_parent_id_index
      on arke_link (parent_id)

  create index  arke_link_child_id_index
      on arke_link (child_id)

  create index  arke_link_configuration_index
      on arke_link (configuration)

  create table arke_auth
  (
      type          jsonb default '{"read": true, "write": true, "delete": false}'::jsonb not null,
      parent_id     varchar(255)                                                          not null
          references arke_system.arke_unit,
      child_id      varchar(255)                                                          not null
          references arke_system.arke_unit,
      configuration jsonb default '{}'::jsonb,
      primary key (parent_id, child_id)
  )

  create index  arke_auth_parent_id_index
      on arke_auth (parent_id)

  create index  arke_auth_child_id_index
      on arke_auth (child_id)

  create index  arke_auth_configuration_index
      on arke_auth (configuration)

