'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import CaseForm from '@/components/CaseForm'
import { useParams } from 'next/navigation'

export default function EditCase() {
    const router = useRouter()
    const params = useParams()
    const [loading, setLoading] = useState(true)
    const [initialData, setInitialData] = useState(null)
    const supabase = createClient()

    useEffect(() => {
        checkUser()
    }, [])

    const checkUser = async () => {
        const { data: { session } } = await supabase.auth.getSession()
        if (!session) {
            router.push('/login')
        } else {
            fetchCase()
        }
    }

    const fetchCase = async () => {
        if (!params.id) return

        try {
            const { data, error } = await supabase
                .from('cases')
                .select('*')
                .eq('case_number', params.id)
                .single()

            if (error) throw error
            setInitialData(data)
        } catch (error) {
            alert('Error fetching case')
            console.error(error)
            router.push('/')
        } finally {
            setLoading(false)
        }
    }

    if (loading) return <div className="p-8 text-center text-white">Loading...</div>

    return (
        <div className="min-h-screen bg-gray-900 py-12 px-4">
            {initialData && <CaseForm initialData={initialData} isEditing={true} />}
        </div>
    )
}
