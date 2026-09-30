import type {Metadata} from 'next';import './globals.css';
export const metadata:Metadata={title:'ตรวจโกง | แจ้งเหตุและตรวจสอบ',description:'ค้นหาประวัติและติดตามการแจ้งเหตุโกง',icons:{icon:'/favicon.svg'}};
export default function RootLayout({children}:{children:React.ReactNode}){return <html lang="th"><body>{children}</body></html>}
