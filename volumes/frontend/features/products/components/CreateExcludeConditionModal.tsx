import { useCallback, useRef } from 'react'

import { Button, Modal } from 'react-daisyui'

const CreateExcludeConditionModal = () => {
  const ref = useRef<HTMLDialogElement>(null)
  const showModal = useCallback(() => {
    ref.current?.showModal()
  }, [ref])

  return (
    <>
      <Button onClick={showModal} color='neutral' size='md' className='w-full'>
        ＋ 除外条件を追加
      </Button>
      <Modal ref={ref} backdrop={true}>
        <Modal.Header className='font-bold'>
          除外条件を追加
          <form method='dialog'>
            <Button size='sm' color='ghost' shape='circle' className='absolute right-2 top-2'>
              ✕
            </Button>
          </form>
        </Modal.Header>
        <Modal.Body>
          <p>ここに追加フォームを実装する</p>
        </Modal.Body>
      </Modal>
    </>
  )
}

export default CreateExcludeConditionModal
