'use client'

import { useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import { useRouter } from 'next/navigation'
import Link from 'next/link'
import { Plus, Trash2, Edit, LogOut } from 'lucide-react'

export default function Dashboard() {
  const [cases, setCases] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const router = useRouter()
  const supabase = createClient()

  useEffect(() => {
    checkUser()
    fetchCases()
  }, [])

  const checkUser = async () => {
    const { data: { session } } = await supabase.auth.getSession()
    if (!session) {
      router.push('/login')
    }
  }

  const fetchCases = async () => {
    try {
      setLoading(true)
      const { data, error } = await supabase
        .from('cases')
        .select('*')
        .order('case_number', { ascending: true })

      if (error) throw error
      setCases(data || [])
    } catch (error) {
      alert('Error fetching cases')
      console.error(error)
    } finally {
      setLoading(false)
    }
  }

  const handleDelete = async (id: number) => {
    if (!confirm('Are you sure you want to delete this case?')) return

    try {
      const { error } = await supabase
        .from('cases')
        .delete()
        .eq('case_number', id)

      if (error) throw error
      fetchCases()
    } catch (error) {
      alert('Error deleting case')
      console.error(error)
    }
  }

  const handleSignOut = async () => {
    await supabase.auth.signOut()
    router.push('/login')
  }

  if (loading) return <div className="p-8 text-center">Loading...</div>

  return (
    <div className="min-h-screen bg-gray-900 text-white p-8">
      <div className="max-w-6xl mx-auto">
        <div className="flex justify-between items-center mb-8">
          <h1 className="text-3xl font-bold">Phone Detective Admin</h1>
          <div className="flex gap-4">
            <Link
              href="/cases/new"
              className="flex items-center gap-2 bg-blue-600 px-4 py-2 rounded hover:bg-blue-700 transition"
            >
              <Plus size={18} /> Add Case
            </Link>
            <button
              onClick={handleSignOut}
              className="flex items-center gap-2 bg-red-600 px-4 py-2 rounded hover:bg-red-700 transition"
            >
              <LogOut size={18} /> Sign Out
            </button>
          </div>
        </div>

        <div className="bg-gray-800 rounded-lg overflow-hidden">
          <table className="w-full">
            <thead className="bg-gray-700">
              <tr>
                <th className="p-4 text-left">#</th>
                <th className="p-4 text-left">Title</th>
                <th className="p-4 text-left">Difficulty</th>
                <th className="p-4 text-left">Actions</th>
              </tr>
            </thead>
            <tbody>
              {cases.length === 0 ? (
                <tr>
                  <td colSpan={4} className="p-8 text-center text-gray-400">
                    No cases found. Add one to get started.
                  </td>
                </tr>
              ) : (
                cases.map((c) => (
                  <tr key={c.case_number} className="border-t border-gray-700 hover:bg-gray-750">
                    <td className="p-4">{c.case_number}</td>
                    <td className="p-4">
                      <div className="font-bold">{c.title}</div>
                      <div className="text-xs text-gray-400">{c.subtitle}</div>
                    </td>
                    <td className="p-4">
                      <span className={`px-2 py-1 rounded text-xs ${c.difficulty === 0 ? 'bg-green-900 text-green-200' :
                        c.difficulty === 1 ? 'bg-yellow-900 text-yellow-200' :
                          'bg-red-900 text-red-200'
                        }`}>
                        {['Beginner', 'Intermediate', 'Advanced'][c.difficulty] || 'Unknown'}
                      </span>
                    </td>
                    <td className="p-4 flex gap-2">
                      <Link
                        href={`/cases/${c.case_number}`}
                        className="p-2 bg-gray-700 rounded hover:bg-gray-600 text-blue-400"
                      >
                        <Edit size={18} />
                      </Link>
                      <button
                        onClick={() => handleDelete(c.case_number)}
                        className="p-2 bg-gray-700 rounded hover:bg-gray-600 text-red-400"
                      >
                        <Trash2 size={18} />
                      </button>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  )
}
