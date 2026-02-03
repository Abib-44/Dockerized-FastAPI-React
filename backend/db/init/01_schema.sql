CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

INSERT INTO users (username, email, password_hash)
VALUES 
('jdoe', 'jdoe@example.com', 'hash1'),
('asmith', 'asmith@example.com', 'hash2'),
('bwayne', 'bwayne@example.com', 'hash3'),
('ckent', 'ckent@example.com', 'hash4'),
('dprince', 'dprince@example.com', 'hash5')
ON CONFLICT (username) DO NOTHING;