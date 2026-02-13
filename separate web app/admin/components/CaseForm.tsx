'use client'

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import { Save, ArrowLeft } from 'lucide-react'
import Link from 'next/link'

interface CaseFormProps {
    initialData?: any
    isEditing?: boolean
}

export default function CaseForm({ initialData, isEditing = false }: CaseFormProps) {
    const router = useRouter()
    const [loading, setLoading] = useState(false)
    const supabase = createClient()
    const [formData, setFormData] = useState({
        case_number: 0,
        title: '',
        subtitle: '',
        description: '',
        scenario: '',
        difficulty: 0,
        contacts: '[]',
        conversations: '[]',
        photos: '[]',
        notes: '[]',
        call_log: '[]',
        emails: '[]',
        solution: '{}',
        hints: '[]',
    })

    useEffect(() => {
        if (initialData) {
            setFormData({
                case_number: initialData.case_number,
                title: initialData.title || '',
                subtitle: initialData.subtitle || '',
                description: initialData.description || '',
                scenario: initialData.scenario || '',
                difficulty: initialData.difficulty || 0,
                contacts: JSON.stringify(initialData.contacts || [], null, 2),
                conversations: JSON.stringify(initialData.conversations || [], null, 2),
                photos: JSON.stringify(initialData.photos || [], null, 2),
                notes: JSON.stringify(initialData.notes || [], null, 2),
                call_log: JSON.stringify(initialData.call_log || [], null, 2),
                emails: JSON.stringify(initialData.emails || [], null, 2),
                solution: JSON.stringify(initialData.solution || {}, null, 2),
                hints: JSON.stringify(initialData.hints || [], null, 2),
            })
        }
    }, [initialData])

    const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
        const { name, value } = e.target
        setFormData(prev => ({ ...prev, [name]: value }))
    }

    const validateJson = (key: string, value: string) => {
        try {
            JSON.parse(value)
            return true
        } catch (e) {
            alert(`Invalid JSON in ${key}`)
            return false
        }
    }

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault()
        setLoading(true)

        // Validate JSON fields
        const jsonFields = ['contacts', 'conversations', 'photos', 'notes', 'call_log', 'emails', 'solution', 'hints']
        for (const field of jsonFields) {
            // @ts-ignore
            if (!validateJson(field, formData[field])) {
                setLoading(false)
                return
            }
        }

        try {
            const payload = {
                title: formData.title,
                subtitle: formData.subtitle,
                description: formData.description,
                scenario: formData.scenario,
                difficulty: Number(formData.difficulty),
                contacts: JSON.parse(formData.contacts),
                conversations: JSON.parse(formData.conversations),
                photos: JSON.parse(formData.photos),
                notes: JSON.parse(formData.notes),
                call_log: JSON.parse(formData.call_log),
                emails: JSON.parse(formData.emails),
                solution: JSON.parse(formData.solution),
                hints: JSON.parse(formData.hints),
            }

            if (isEditing) {
                const { error } = await supabase
                    .from('cases')
                    .update(payload)
                    .eq('case_number', formData.case_number)
                if (error) throw error
            } else {
                const { error } = await supabase
                    .from('cases')
                    .insert({ ...payload, case_number: Number(formData.case_number) })
                if (error) throw error
            }

            router.push('/')
            router.refresh()
        } catch (error: any) {
            alert(error.message || 'Error saving case')
        } finally {
            setLoading(false)
        }
    }

    return (
        <div className="max-w-4xl mx-auto bg-gray-800 p-8 rounded-lg shadow-xl text-white">
            <div className="flex items-center gap-4 mb-8">
                <Link href="/" className="text-gray-400 hover:text-white">
                    <ArrowLeft size={24} />
                </Link>
                <h1 className="text-2xl font-bold">{isEditing ? `Edit Case #${formData.case_number}` : 'New Case'}</h1>
            </div>

            <form onSubmit={handleSubmit} className="space-y-6">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label className="block text-sm font-medium mb-1">Case Number</label>
                        <input
                            type="number"
                            name="case_number"
                            value={formData.case_number}
                            onChange={handleChange}
                            disabled={isEditing}
                            className="w-full p-2 rounded bg-gray-700 border border-gray-600 focus:border-blue-500 focus:outline-none disabled:opacity-50"
                            required
                        />
                    </div>
                    <div>
                        <label className="block text-sm font-medium mb-1">Difficulty</label>
                        <select
                            name="difficulty"
                            value={formData.difficulty}
                            onChange={handleChange}
                            className="w-full p-2 rounded bg-gray-700 border border-gray-600 focus:border-blue-500 focus:outline-none"
                        >
                            <option value={0}>Beginner</option>
                            <option value={1}>Intermediate</option>
                            <option value={2}>Advanced</option>
                        </select>
                    </div>
                </div>

                <div>
                    <label className="block text-sm font-medium mb-1">Title</label>
                    <input
                        type="text"
                        name="title"
                        value={formData.title}
                        onChange={handleChange}
                        className="w-full p-2 rounded bg-gray-700 border border-gray-600 focus:border-blue-500 focus:outline-none"
                        required
                    />
                </div>

                <div>
                    <label className="block text-sm font-medium mb-1">Subtitle</label>
                    <input
                        type="text"
                        name="subtitle"
                        value={formData.subtitle}
                        onChange={handleChange}
                        className="w-full p-2 rounded bg-gray-700 border border-gray-600 focus:border-blue-500 focus:outline-none"
                    />
                </div>

                <div>
                    <label className="block text-sm font-medium mb-1">Description</label>
                    <textarea
                        name="description"
                        value={formData.description}
                        onChange={handleChange}
                        className="w-full p-2 rounded bg-gray-700 border border-gray-600 focus:border-blue-500 focus:outline-none h-24"
                    />
                </div>

                <div>
                    <label className="block text-sm font-medium mb-1">Scenario</label>
                    <textarea
                        name="scenario"
                        value={formData.scenario}
                        onChange={handleChange}
                        className="w-full p-2 rounded bg-gray-700 border border-gray-600 focus:border-blue-500 focus:outline-none h-24"
                    />
                </div>

                <div className="border-t border-gray-700 pt-6">
                    <h3 className="text-xl font-semibold mb-4 text-blue-400">JSON Data Fields</h3>
                    <p className="text-sm text-gray-400 mb-4">Paste valid JSON arrays or objects below.</p>

                    <div className="space-y-4">
                        {['contacts', 'conversations', 'photos', 'notes', 'call_log', 'emails', 'hints'].map((field) => (
                            <div key={field}>
                                <label className="block text-sm font-medium mb-1 capitalize">{field.replace('_', ' ')} (Array)</label>
                                <textarea
                                    name={field}
                                    // @ts-ignore
                                    value={formData[field]}
                                    onChange={handleChange}
                                    className="w-full p-2 rounded bg-gray-700 border border-gray-600 focus:border-blue-500 focus:outline-none h-32 font-mono text-sm"
                                />
                            </div>
                        ))}

                        <div>
                            <label className="block text-sm font-medium mb-1">Solution (Object)</label>
                            <textarea
                                name="solution"
                                value={formData.solution}
                                onChange={handleChange}
                                className="w-full p-2 rounded bg-gray-700 border border-gray-600 focus:border-blue-500 focus:outline-none h-48 font-mono text-sm"
                            />
                        </div>
                    </div>
                </div>

                <div className="flex justify-end pt-6">
                    <button
                        type="submit"
                        disabled={loading}
                        className="flex items-center gap-2 bg-blue-600 hover:bg-blue-700 px-6 py-3 rounded font-bold transition disabled:opacity-50"
                    >
                        <Save size={20} />
                        {loading ? 'Saving...' : 'Save Case'}
                    </button>
                </div>
            </form>
        </div>
    )
}
