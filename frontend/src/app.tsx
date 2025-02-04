import React from "react";

export const App = () => {
  const [response, setResponse] = React.useState<null | string>();
  const fetchFromBackend = async () => {
    const response = await fetch("https://backend-crimson-butterfly-8433.fly.dev", { credentials: 'include' });
    setResponse(await response.text());
  };
  if (response == null) {
    return <button onClick={fetchFromBackend}>fetch date and time from backend</button>;
  }
  return <div>Response from backend: {response}</div>;
};
