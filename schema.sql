-- JÁ APLICADO no Supabase (projeto cecilia-rodrigues). Guardado só como referência.
-- Cole no Supabase: SQL Editor > New query > Run

create table services(
  id uuid primary key default gen_random_uuid(),
  name text not null, description text default '',
  category text not null default 'Outros', -- Maquiagem, Sobrancelha, Cílios, Epilação
  price numeric not null default 100,
  active boolean not null default true, sort int not null default 0);

create table bookings(
  id uuid primary key default gen_random_uuid(),
  client_name text not null, phone text not null,
  services jsonb not null, total numeric not null,
  dia date not null, hora text not null,
  created_at timestamptz default now());
create unique index one_client_per_slot on bookings(dia, hora); -- impede horario duplicado

create table blocked(
  id uuid primary key default gen_random_uuid(),
  dia date not null, hora text, -- hora vazia = dia inteiro bloqueado
  motivo text default '');

alter table services enable row level security;
alter table bookings enable row level security;
alter table blocked enable row level security;

-- clientes (site): veem so servicos ativos e podem apenas CRIAR agendamento
create policy "ver servicos ativos" on services for select to anon using (active);
create policy "cliente agenda" on bookings for insert to anon
  with check (dia >= current_date and length(client_name) between 2 and 80);
-- admin logada: acesso total
create policy "admin servicos" on services for all to authenticated using (true) with check (true);
create policy "admin agenda" on bookings for all to authenticated using (true) with check (true);
create policy "admin bloqueios" on blocked for all to authenticated using (true) with check (true);

-- o site descobre horarios ocupados SEM ver nome/telefone de ninguem
create function busy_slots(d date) returns table(t text)
language sql security definer set search_path = public as $$
  select hora from bookings where dia = d
  union select coalesce(nullif(hora,''),'ALL') from blocked where dia = d $$;
grant execute on function busy_slots(date) to anon, authenticated;

-- se o banco já foi criado antes, rode só:  alter table services add column category text not null default 'Outros';
insert into services(name,description,category,price,sort) values
 ('Maquiagem Social','Acabamento impecável e duradouro para o seu evento.','Maquiagem',100,1),
 ('Design de Sobrancelhas','Modelagem personalizada para o formato do seu rosto.','Sobrancelha',100,2),
 ('Buço','Remoção rápida e delicada, com acabamento suave.','Epilação',100,3),
 ('Brow Lamination','Fios alinhados para uma sobrancelha cheia e definida.','Sobrancelha',100,4),
 ('Lash Lifting','Cílios levantados e curvados, com olhar aberto por semanas.','Cílios',100,5);

-- textos e ajustes do site (painel > aba Site)
create table settings(key text primary key, value text not null default '');
alter table settings enable row level security;
create policy "site le ajustes" on settings for select to anon using (true);
create policy "admin ajustes" on settings for all to authenticated using (true) with check (true);
