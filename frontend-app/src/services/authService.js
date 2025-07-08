import BACKEND_URI from "./BACKEND_URI";
//
const API = BACKEND_URI;

export async function loginReceptor(cedula, password) {
  const res = await fetch(`${API}/auth/receptor/login`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ Cedula: cedula, Password: password }),
  });
  if (!res.ok) throw new Error("Login fallido");
  return res.json();
}

// Recibe el token temporal para votar.
export async function getVoteToken(cedula, password) {
  const res = await fetch(`${API}/auth/enable-vote`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ Cedula: cedula, Password: password }),
  });
  if (!res.ok) throw new Error("Error habilitando voto");
  return res.json();
}
