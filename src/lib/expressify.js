// src: https://github.com/ashleyconnor/sveltekit-supabase-demo
import * as cookie from 'cookie'

export const toExpressRequest = (req) => ({
  ...req,
  cookies: cookie.parse(req.headers.cookie || '')
})

export const toExpressResponse = (res) => ({
  ...res,
  getHeader: (header) => res.headers[header.toLowerCase()],
  setHeader: (header, value) => (res.headers[header.toLowerCase()] = value),
  status: (_) => ({ json: (_) => {} })
})

export const toSveltekitResponse = (res) => {
  const { getHeader, setHeader, ...returnAbleResp } = res
  return returnAbleResp
}
