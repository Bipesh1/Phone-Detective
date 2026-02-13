'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import CaseForm from '@/components/CaseForm'

export default function NewCase() {
    const router = useRouter()
    const [loading, setLoading] = useState(true)
    const supabase = createClient()

    useEffect(() => {
        checkUser()
    }, [])

    const checkUser = async () => {
        const { data: { session } } = await supabase.auth.getSession()
        if (!session) {
            router.push('/login')
        } else {
            setLoading(false)
        }
    }

    if (loading) return <div className="p-8 text-center text-white">Loading...</div>

    return (
        <div className="min-h-screen bg-gray-900 py-12 px-4">
            <CaseForm />
        </div>
    )
}
