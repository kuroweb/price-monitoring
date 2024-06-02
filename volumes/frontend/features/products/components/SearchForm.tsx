'use client'

import { usePerState } from '../hooks/usePerState'
import { usePlatformState } from '../hooks/usePlatformState'
import { useStatusState } from '../hooks/useStatusState'

const SearchForm = () => {
  const [platform, setPlatform] = usePlatformState()
  const [status, setStatus] = useStatusState()
  const [per, setPer] = usePerState()

  const handlePlatformChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    setPlatform(e.target.value)
  }

  const handlePublishedChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    setStatus(e.target.value)
  }

  const handlePerChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    setPer(Number(e.target.value))
  }

  type Option = {
    value: string
    label: string
  }

  type SelectFieldProps = {
    label: string
    value: string
    onChange: (e: React.ChangeEvent<HTMLSelectElement>) => void
    options: Option[]
  }

  const platformOptions: Option[] = [
    { value: 'all', label: 'すべて' },
    { value: 'yahoo_auction', label: 'ヤフオク' },
    { value: 'yahoo_fleamarket', label: 'ペイペイ' },
    { value: 'mercari', label: 'メルカリ' },
    { value: 'janpara', label: 'じゃんぱら' },
    { value: 'iosys', label: 'イオシス' },
    { value: 'pc_koubou', label: 'パソコン工房' },
    { value: 'used_sofmap', label: 'リコレ' },
  ]

  const statusOptions: Option[] = [
    { value: 'published', label: '出品中' },
    { value: 'unpublished', label: '売り切れ' },
  ]

  const perOptions: Option[] = [
    { value: '10', label: '10件' },
    { value: '50', label: '50件' },
    { value: '100', label: '100件' },
  ]

  const SelectField = ({ label, value, onChange, options }: SelectFieldProps) => (
    <label className='form-control w-32 pr-2'>
      <div className='label'>
        <span className='label-text'>{label}</span>
      </div>
      <select className='select select-bordered' onChange={onChange} value={value}>
        {options.map((option) => (
          <option key={option.value} value={option.value}>
            {option.label}
          </option>
        ))}
      </select>
    </label>
  )

  const showStatusField = ['all', 'yahoo_auction', 'yahoo_fleamarket', 'mercari'].includes(platform)

  return (
    <div className='flex flex-wrap'>
      <SelectField
        label='プラットフォーム'
        value={platform}
        onChange={handlePlatformChange}
        options={platformOptions}
      />
      {showStatusField && (
        <SelectField
          label='ステータス'
          value={status}
          onChange={handlePublishedChange}
          options={statusOptions}
        />
      )}
      <SelectField
        label='表示数'
        value={per.toString()}
        onChange={handlePerChange}
        options={perOptions}
      />
    </div>
  )
}

export default SearchForm
