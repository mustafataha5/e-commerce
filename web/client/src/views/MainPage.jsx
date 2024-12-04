import React, { useEffect, useState } from 'react'
import axios from 'axios' ; 
import { useNavigate } from 'react-router-dom';
import Navbar from '../component/Navbar';
const MainPage = ({getUser=()=>{}}) => {

    

      useEffect(()=>{
        getUser();
      },[]);


  return (
    <div>
      <Navbar />
      <p className='text-center'>Main Page </p>
    </div>
  )
}

export default MainPage
