  if (!req.http.Fastly-SSL) {
    error 801 "Force TLS";
  }