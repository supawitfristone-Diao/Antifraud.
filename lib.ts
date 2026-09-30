import {env} from 'cloudflare:workers';
import {cookies} from 'next/headers';
export const db=()=>{if(!env.DB)throw Error('ฐานข้อมูลยังไม่พร้อมใช้งาน');return env.DB};
export const bucket=()=>{if(!env.BUCKET)throw Error('ที่เก็บหลักฐานยังไม่พร้อมใช้งาน');return env.BUCKET};
const enc=new TextEncoder();
const hex=(b:ArrayBuffer)=>Array.from(new Uint8Array(b)).map(x=>x.toString(16).padStart(2,'0')).join('');
export async function sha(s:string){return hex(await crypto.subtle.digest('SHA-256',enc.encode(s)))}
export async function password(s:string,salt=crypto.randomUUID()){const key=await crypto.subtle.importKey('raw',enc.encode(s),'PBKDF2',false,['deriveBits']);return salt+':'+hex(await crypto.subtle.deriveBits({name:'PBKDF2',salt:enc.encode(salt),iterations:150000,hash:'SHA-256'},key,256))}
export async function verifyPassword(s:string,stored:string){const [salt]=stored.split(':');return (await password(s,salt))===stored}
export async function currentUser(){const c=(await cookies()).get('session')?.value;if(!c)return null;const row=await db().prepare('SELECT u.id,u.full_name AS fullName,u.phone,u.role FROM sessions s JOIN users u ON u.id=s.user_id WHERE s.token_hash=? AND s.expires_at > ?').bind(await sha(c),new Date().toISOString()).first<{id:number;fullName:string;phone:string;role:string}>();return row||null}
export async function issueSession(userId:number){const token=crypto.randomUUID()+crypto.randomUUID();await db().prepare('INSERT INTO sessions(token_hash,user_id,expires_at) VALUES(?,?,?)').bind(await sha(token),userId,new Date(Date.now()+7*86400000).toISOString()).run();(await cookies()).set('session',token,{httpOnly:true,secure:true,sameSite:'lax',path:'/',maxAge:604800})}
export function fail(message:string,status=400){return Response.json({error:message},{status})}
export function ok(data:unknown){return Response.json(data)}
export function validPhone(v:string){return /^0\d{9}$/.test(v)}
