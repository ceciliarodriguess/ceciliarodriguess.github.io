-- Rodar no Supabase: SQL Editor > New query > Run
-- Atualiza precos e servicos conforme o portfolio enviado pela Cecilia.
update services set price=130, sort=1 where name='Maquiagem Social';
update services set name='Design de Sobrancelhas Simples', price=40, sort=2 where name='Design de Sobrancelhas';
update services set price=130, sort=5 where name='Brow Lamination';
update services set price=150, sort=6, description='Cílios levantados e curvados, com olhar aberto por semanas. Não realizamos extensão de cílios.' where name='Lash Lifting';
-- Buço fica escondido do site ate confirmar o valor. Depois: update services set price=XX, active=true where name='Buço';
update services set active=false, sort=7 where name='Buço';
insert into services(name,description,category,price,sort) values
 ('Design de Sobrancelhas com Henna','Design com henna para realçar o preenchimento e a definição dos fios.','Sobrancelha',50,3),
 ('Design de Sobrancelhas com Tintura','Design com tintura para uma sobrancelha mais marcada e natural.','Sobrancelha',50,4);
