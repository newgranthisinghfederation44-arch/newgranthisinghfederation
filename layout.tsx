import type { Metadata } from 'next';
import './globals.css';
export const metadata: Metadata = { title: 'NGSF Portal', description: 'New Granthi Singh Federation secure management portal' };
export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) { return <html lang="en"><body>{children}</body></html>; }
