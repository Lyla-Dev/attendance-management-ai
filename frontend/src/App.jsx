// import Chatbot from "@/components/Chatbot";
// import React, { useState } from "react";
// import logo from "@/assets/images/logo.png";
// import speaker from "@/assets/images/Img.png";
// import popup from "src/components/popup";

// // const Modal = ({ onClose, children }) => {
// //   return (
// //     <div
// //       className="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full"
// //       onClick={onClose}
// //     >
// //       <div
// //         className="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white"
// //         onClick={(e) => e.stopPropagation()} // 모달 배경 클릭 시 닫히지 않도록 이벤트 전파 중단
// //       >
// //         <div className="mt-3 text-center">{children}</div>
// //       </div>
// //     </div>
// //   );
// // };

// function App() {
//   const [isModalOpen, setIsModalOpen] = useState(false);

//   const handleBannerClick = () => {
//     setIsModalOpen(true);
//   };

//   const handleModalClose = () => {
//     setIsModalOpen(false);
//   };
//   return (
//     <div className="flex flex-col min-h-full w-full max-w-3xl mx-auto px-4">
//       <header className="sticky top-0 shrink-0 z-20 bg-white">
//         <div className="flex flex-col h-full w-full gap-1 pt-4 pb-2">
//           <a href="https://codeawake.com">
//             <img src={logo} className="w-32" alt="logo" />
//           </a>
//           <h1 className="font-urbanist text-[1.65rem] font-semibold">
//             언제와 챗봇에 문의하기
//           </h1>
//           <h3 className="font-urbanist text-sm text-gray-500">
//             언제와 챗봇이 대기없이 24시간 답변을 해드립니다.
//           </h3>

//           <div
//             className="flex items-center p-4 bg-pink-100 rounded-2xl cursor-pointer mt-6"
//             style={{ backgroundColor: "#FFDED1" }}
//             onClick={handleBannerClick}
//           >
//             {/* 아이콘 부분 */}
//             <div className="flex-shrink-0 mr-4">
//               <img src={speaker} alt="speaker icon" className="w-12 h-12" />
//             </div>

//             {/* 텍스트 부분 */}
//             <div className="flex flex-col">
//               <span className="text-sm text-black-500 font-medium">
//                 5/1~5/14
//               </span>
//               <span className="text-lg font-bold text-gray-800">
//                 교외 체험 학습 신청 안내
//               </span>
//             </div>
//           </div>

//           {/* 팝업 모달 컴포넌트 */}
//           {isModalOpen && (
//             <popup onClose={handleModalClose}>
//               {/* 팝업 화면에 표시될 내용 */}
//               <div>
//                 <button
//                   onClick={handleModalClose}
//                   className="mt-4 px-4 py-2 bg-indigo-600 text-white text-base font-medium rounded-md shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
//                 >
//                   닫기
//                 </button>
//               </div>
//             </popup>
//           )}
//         </div>
//       </header>
//       <Chatbot />
//     </div>
//   );
// }

// export default App;

import Chatbot from "@/components/Chatbot";
import React, { useState } from "react";
import logo from "@/assets/images/logo.png";
import speaker from "@/assets/images/Img.png";
// import popup from "src/components/popup"; // 기존 팝업 컴포넌트 주석 처리

// ScolipeCard 컴포넌트를 App.js 파일 내부에 정의
const ScolipeCard = ({ onClose }) => {
  return (
    <div className="w-[348px] h-[355px] bg-white rounded-xl shadow-lg p-6 flex flex-col font-sans">
      <header className="mb-5">
        <p className="text-lg font-semibold text-gray-800 mb-1">5/1 ~ 5/14</p>
        <h1 className="text-2xl font-bold text-black">
          교외 체험 학습 신청 안내
        </h1>
      </header>
      <main className="flex-grow text-black">
        <p className="text-sm leading-relaxed mb-4">
          체험학습 신청시 체험학습 시작 일 2일 전에 신청하셔야 합니다.
        </p>
        <p className="text-sm leading-relaxed">
          신청 기한을 반드시 확인해주시고, 담임 선생님께 교외 체험학습 신청서를
          제출해 주시기 바랍니다.
        </p>
      </main>
      <footer className="flex justify-between items-center mt-4">
        <button className="w-[142px] h-[53px] rounded-md bg-[#F0EBE8] text-[#6D4646] font-bold text-base flex items-center justify-center transition-transform transform hover:scale-105 hover:shadow-md focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-[#D8C8C1]">
          직접 문의하기
        </button>
        <button
          onClick={onClose} // "확인했습니다" 버튼 클릭 시 모달 닫기
          className="w-[142px] h-[53px] rounded-md bg-[#FF7D05] text-white font-bold text-base flex items-center justify-center transition-transform transform hover:scale-105 hover:shadow-md focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-[#FF7D05]"
        >
          확인했습니다
        </button>
      </footer>
    </div>
  );
};

const Modal = ({ onClose, children }) => {
  return (
    <div
      className="fixed inset-0 bg-gray-300 bg-opacity-70 overflow-y-auto h-full w-full flex justify-center items-center"
      onClick={onClose}
    >
      <div
        className="relative p-5 shadow-lg rounded-md bg-white"
        onClick={(e) => e.stopPropagation()} // 모달 배경 클릭 시 닫히지 않도록 이벤트 전파 중단
      >
        {children}
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
            <div className="flex-shrink-0 mr-4">
              <img src={speaker} alt="speaker icon" className="w-12 h-12" />
            </div>
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
              <ScolipeCard onClose={handleModalClose} />
            </Modal>
          )}
        </div>
      </header>
      <Chatbot />
    </div>
  );
}

export default App;
