import React from 'react';

// 메인 카드 컴포넌트
const ScolipeCard = () => {
  return (
    // 전체 카드 레이아웃: 크기, 배경, 그림자, 패딩 등 설정
    <div className="w-[348px] h-[355px] bg-white rounded-xl shadow-lg p-6 flex flex-col font-sans">
      
      {/* 카드 헤더: 날짜와 제목 포함 */}
      <header className="mb-5">
        {/* 날짜 추가 */}
        <p className="text-lg font-semibold text-gray-800 mb-1">
          5/1 ~ 5/14
        </p>
        {/* 제목 수정 */}
        <h1 className="text-2xl font-bold text-black">
          교외 체험 학습 신청 안내
        </h1>
      </header>

      {/* 카드 본문: 내용 수정 */}
      <main className="flex-grow text-black">
        <p className="text-sm leading-relaxed mb-4">
          체험학습 신청시 체험학습 시작 일 2일 전에 신청하셔야 합니다.
        </p>
        <p className="text-sm leading-relaxed">
          신청 기한을 반드시 확인해주시고, 담임 선생님께 교외 체험학습 신청서를 제출해 주시기 바랍니다.
        </p>
      </main>

      {/* 카드 푸터: 버튼 텍스트 수정 및 아이콘 제거 */}
      <footer className="flex justify-between items-center mt-4">
        {/* '직접 문의하기' 버튼 */}
        <button className="w-[142px] h-[53px] rounded-md bg-[#F0EBE8] text-[#6D4646] font-bold text-base flex items-center justify-center transition-transform transform hover:scale-105 hover:shadow-md focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-[#D8C8C1]">
          직접 문의하기
        </button>
        {/* '확인했습니다' 버튼 */}
        <button className="w-[142px] h-[53px] rounded-md bg-[#FF7D05] text-white font-bold text-base flex items-center justify-center transition-transform transform hover:scale-105 hover:shadow-md focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-[#FF7D05]">
          확인했습니다
        </button>
      </footer>
    </div>
  );
};


// 이 컴포넌트를 렌더링하기 위한 App 컴포넌트
export default function App() {
  return (
    <div className="flex justify-center items-center min-h-screen w-full bg-gray-100">
      <ScolipeCard />
    </div>
  );
}

