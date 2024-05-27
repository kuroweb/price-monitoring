import { create } from 'zustand'

type EditCrawlSettingModalState = {
  isOpen: boolean
  open: () => void
  close: () => void
}

export const useEditCrawlSettingModalStore = create<EditCrawlSettingModalState>((set) => ({
  isOpen: false,
  open: () => set(() => ({ isOpen: true })),
  close: () => set(() => ({ isOpen: false })),
}))
