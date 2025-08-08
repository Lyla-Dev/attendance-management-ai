import Chatbot from "@/components/Chatbot";
import React, { useState } from "react";
import logo from "@/assets/images/logo.png";
import speaker from "@/assets/images/Img.png";

const Modal = ({ onClose, children }) => {
  return (
    <div
      className="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full"
      onClick={onClose}
    >
      <div
        className="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white"
        onClick={(e) => e.stopPropagation()} // 모달 배경 클릭 시 닫히지 않도록 이벤트 전파 중단
      >
        <div className="mt-3 text-center">{children}</div>
      </div>
    </div>
  );
};

function App() {
  const [isModalOpen, setIsModalOpen] = useState(false);

  const handleBannerClick = () => {
    setIsModalOpen(true);
  };

  const handleModalClose = () => {
    setIsModalOpen(false);
  };
  return (
    <div className="flex flex-col min-h-full w-full max-w-3xl mx-auto px-4">
      <header className="sticky top-0 shrink-0 z-20 bg-white">
        <div className="flex flex-col h-full w-full gap-1 pt-4 pb-2">
          <a href="https://codeawake.com">
            <img src={logo} className="w-32" alt="logo" />
          </a>
          <h1 className="font-urbanist text-[1.65rem] font-semibold">
            언제와 챗봇에 문의하기
          </h1>
          <h3 className="font-urbanist text-sm text-gray-500">
            언제와 챗봇이 대기없이 24시간 답변을 해드립니다.
          </h3>

          <div
            className="flex items-center p-4 bg-pink-100 rounded-2xl cursor-pointer mt-6"
            style={{ backgroundColor: "#FFDED1" }}
            onClick={handleBannerClick}
          >
            {/* 아이콘 부분 */}
            <div className="flex-shrink-0 mr-4">
              <img src={speaker} alt="speaker icon" className="w-12 h-12" />
            </div>

            {/* 텍스트 부분 */}
            <div className="flex flex-col">
              <span className="text-sm text-black-500 font-medium">
                5/1~5/14
              </span>
              <span className="text-lg font-bold text-gray-800">
                교외 체험 학습 신청 안내
              </span>
            </div>
          </div>

          {/* 팝업 모달 컴포넌트 */}
          {isModalOpen && (
            <Modal onClose={handleModalClose}>
              {/* 팝업 화면에 표시될 내용 */}
              <div>
                <h2 className="text-xl font-bold mb-4">
                  교외 체험 학습 신청 안내
                </h2>
                <p>팝업 화면에 표시될 상세 내용이 여기에 들어갑니다.</p>
                <p>이것은 테스트 모달입니다.</p>
                <p className="mt-2 text-gray-600">
                  더 자세한 내용은 학교 홈페이지를 참고해주세요.
                </p>
                <button
                  onClick={handleModalClose}
                  className="mt-4 px-4 py-2 bg-indigo-600 text-white text-base font-medium rounded-md shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                >
                  닫기
                </button>
              </div>
            </Modal>
          )}
        </div>
      </header>
      <Chatbot />
    </div>
  );
}

export default App;
