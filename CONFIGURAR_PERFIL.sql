-- Executar no Supabase SQL Editor com papel administrativo (postgres).
-- Não cria usuários Auth. Primeiro cadastre o e-mail em Authentication > Users.

-- 1) Conferir usuário e respectivo perfil
SELECT u.id, u.email, u.email_confirmed_at, p.nome, p.papel
FROM auth.users u LEFT JOIN public.perfis p ON p.id = u.id
WHERE lower(u.email) = 'ana.paula.vila.borba@gmail.com';

-- 2) Criar o perfil ou atualizar como editora, reutilizando o UUID do Auth.
-- Se o usuário ainda não existir em Authentication > Users, a operação gerará um erro claro.
DO $$
DECLARE v_id uuid;
BEGIN
  SELECT id INTO v_id FROM auth.users
  WHERE lower(email) = 'ana.paula.vila.borba@gmail.com';
  IF v_id IS NULL THEN
    RAISE EXCEPTION 'Usuária não encontrada em Authentication > Users. Crie ou convide a usuária antes.';
  END IF;
  INSERT INTO public.perfis (id, email, nome, papel)
  VALUES (v_id, 'ana.paula.vila.borba@gmail.com', 'Ana Paula', 'editor')
  ON CONFLICT (id) DO UPDATE SET
    email = EXCLUDED.email, nome = EXCLUDED.nome, papel = 'editor';
END $$;

-- 3) Conferir resultado
SELECT u.id, u.email, p.nome, p.papel
FROM auth.users u JOIN public.perfis p ON p.id = u.id
WHERE lower(u.email) = 'ana.paula.vila.borba@gmail.com';
