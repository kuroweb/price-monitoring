const Breadcrumbs = ({ text, className }: { text: string; className?: string }) => {
  return (
    <ol
      className={`flex items-center whitespace-nowrap min-w-0 ${className}`}
      aria-label='Breadcrumb'
    >
      <li className='text-sm text-gray-500'>
        <div className='flex items-center'>
          <span className='font-semibold'>{text}</span>
        </div>
      </li>
    </ol>
  )
}

export default Breadcrumbs
